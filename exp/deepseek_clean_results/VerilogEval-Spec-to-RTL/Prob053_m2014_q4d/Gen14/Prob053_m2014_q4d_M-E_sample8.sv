module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out = 1'b0;  // Initialize to 0
    wire next_state = in ? ~d_out : d_out;

    always @(posedge clk) begin
        d_out <= next_state;
    end

    assign out = d_out;

endmodule