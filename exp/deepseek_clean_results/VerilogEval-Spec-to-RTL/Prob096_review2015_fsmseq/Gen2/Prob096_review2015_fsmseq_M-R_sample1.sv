module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State parameters using binary encoding
    parameter [1:0] IDLE   = 2'b00,
                    GOT1   = 2'b01,
                    GOT11  = 2'b10,
                    GOT110 = 2'b11,
                    FOUND  = 2'b00; // Reuses IDLE encoding since we never leave FOUND

    reg [1:0] state;
    reg found_reg;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found_reg <= 1'b0;
        end else if (!found_reg) begin
            case (state)
                IDLE:   state <= data ? GOT1 : IDLE;
                GOT1:   state <= data ? GOT11 : IDLE;
                GOT11:  state <= data ? GOT11 : GOT110;
                GOT110: begin
                    state <= data ? FOUND : IDLE;
                    found_reg <= data ? 1'b1 : 1'b0;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output is purely combinational
    assign start_shifting = found_reg;

endmodule