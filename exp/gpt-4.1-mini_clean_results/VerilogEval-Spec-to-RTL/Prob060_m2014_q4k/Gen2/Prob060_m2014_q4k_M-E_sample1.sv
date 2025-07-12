module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg dff0, dff1, dff2, dff3;
    wire dff0_next, dff1_next, dff2_next, dff3_next;

    // Next state logic for the ring shift register
    assign dff0_next = in;
    assign dff1_next = dff0;
    assign dff2_next = dff1;
    assign dff3_next = dff2;

    always @(posedge clk) begin
        if (~resetn) begin
            dff0 <= 1'b0;
            dff1 <= 1'b0;
            dff2 <= 1'b0;
            dff3 <= 1'b0;
        end else begin
            dff0 <= dff0_next;
            dff1 <= dff1_next;
            dff2 <= dff2_next;
            dff3 <= dff3_next;
        end
    end

    assign out = dff3;

endmodule