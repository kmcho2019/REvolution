module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);

    // 4-bit shift register: dff[0] is the first stage, dff[3] is the last
    reg [3:0] dff;

    always @(posedge clk) begin
        if (~resetn)
            dff <= 4'b0000;        // synchronous active-low reset
        else
            dff <= {dff[2:0], in}; // shift left and input new bit
    end

    assign out = dff[3];           // output from last stage

endmodule