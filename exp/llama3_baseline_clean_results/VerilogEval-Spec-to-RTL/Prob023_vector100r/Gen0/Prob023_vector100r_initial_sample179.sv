module TopModule(
    input  [99:0] in,
    output [99:0] out
    );

    assign out = in[99:0];

    // Alternatively, you can use a loop for more complex assignments
    // But in this case, direct assignment as shown above is the most straightforward and efficient way

    // However, if you insist on using a loop or want to understand how it works:
    // always @(*) begin
    //     for (int i = 0; i < 100; i++) begin
    //         out[i] = in[99 - i];
    //     end
    // end

endmodule