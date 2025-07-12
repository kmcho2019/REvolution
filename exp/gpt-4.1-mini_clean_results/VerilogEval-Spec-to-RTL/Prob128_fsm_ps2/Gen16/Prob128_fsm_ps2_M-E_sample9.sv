module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01; // First byte detected
    localparam BYTE2 = 2'b10; // Second byte received
    localparam BYTE3 = 2'b11; // Third byte received

    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3]) // Start byte detected
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done <= (state == BYTE3); // done asserted one cycle after 3rd byte received
        end
    end

endmodule