module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [7:0] state; // Using 8 bits to define the internal states
reg [7:0] nextState; // Next state of the state machine
reg [31:0] count; // Counter to store the 1's complement of the input bits
reg [31:0] temp; // Temporary variable
reg done; // Flag to check if the conversion is complete
reg temp_out; // Temporary output variable

localparam IDLE = 8'b00000001;
localparam OnesComplement = 8'b00000010;
localparam TwosComplement = 8'b00000011;

initial begin
    state = IDLE;
    count = 0;
    temp = 0;
    done = 1'b0;
    temp_out = 1'b0;
end

always @ (posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE;
        count <= 0;
        done <= 1'b0;
        temp_out <= 1'b0;
    end
    else begin
        case(state)
            IDLE: begin
                if(!areset) begin
                    state <= OnesComplement;
                end
                else begin
                    state <= IDLE;
                end
            end
            OnesComplement: begin
                count <= {count[30:0], ~x}; // Accumulate 1's complement of input bits
                state <= OnesComplement;
            end
            TwosComplement: begin
                state <= TwosComplement;
            end
            default: begin
                state <= IDLE;
            end
        endcase

        // Generate output
        if(state == OnesComplement) begin
            temp_out <= ~x; // Output the 1's complement of input bits
        end
        else if(state == TwosComplement) begin
            temp_out <= count[0]; // Output the 2's complement
        end
        else begin
            temp_out <= 1'b0; // Default output
        end

        // Move to TwosComplement state when areset is asserted
        if(areset) begin
            state <= TwosComplement;
        end
    end
end

assign z = temp_out;

endmodule