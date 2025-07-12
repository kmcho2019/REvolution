module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding and output combined into a 2-bit register:
    // bit 1: state (0=OFF,1=ON)
    // bit 0: output corresponding to the state (0 or 1)
    reg [1:0] state_out;

    always @(posedge clk) begin
        if (reset) begin
            state_out <= 2'b00; // OFF state with output=0
        end else begin
            case (state_out[1])
                1'b0: // OFF state
                    if (j)
                        state_out <= 2'b11; // ON state with output=1
                    else
                        state_out <= 2'b00; // stay OFF
                1'b1: // ON state
                    if (k)
                        state_out <= 2'b00; // OFF state with output=0
                    else
                        state_out <= 2'b11; // stay ON
                default:
                    state_out <= 2'b00;
            endcase
        end
    end

    assign out = state_out[0];

endmodule