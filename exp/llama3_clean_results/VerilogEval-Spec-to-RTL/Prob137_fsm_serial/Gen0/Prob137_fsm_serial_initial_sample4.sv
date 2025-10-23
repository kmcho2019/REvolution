module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: STOP
reg [7:0] data; // Store the received data bits
reg [2:0] counter; // Counter for 8 data bits
reg done_reg; // Register for the done signal

// Enum for state values
localparam IDLE = 3'b001;
localparam START = 3'b010;
localparam STOP = 3'b100;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        counter <= 0;
        done_reg <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(!in) begin
                    state <= START;
                    counter <= 1;
                    data[0] <= in;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                data[counter] <= in;
                if(counter == 8) begin
                    state <= STOP;
                end else begin
                    counter <= counter + 1;
                end
            end
            STOP: begin
                if(in) begin
                    done_reg <= 1;
                    state <= IDLE;
                end else begin
                    state <= IDLE; // Wait for stop bit
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign done = done_reg;
always @(posedge clk) begin
    done_reg <= 0; // Reset done signal on next clock cycle
end

endmodule