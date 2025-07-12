module TopModule (
    input clk,
    input in,
    output out
);

    reg delayed_out;
    wire xor_out = in ^ delayed_out;

    always @(posedge clk) begin
        delayed_out <= xor_out;
    end

    assign out = delayed_out;

endmodule