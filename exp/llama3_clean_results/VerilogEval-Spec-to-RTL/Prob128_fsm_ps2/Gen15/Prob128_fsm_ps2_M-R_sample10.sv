module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'd0;
    end else begin
        case (state)
            2'd0: if (in[3]) state <= 2'd1; // SEARCH to BYTE1
            2'd1: state <= 2'd2; // BYTE1 to BYTE2
            2'd2: state <= 2'd0; // BYTE2 to SEARCH
            default: state <= 2'd0; // default to SEARCH state
        endcase
    end
end

assign done = (state == 2'd2);

endmodule