module TopModule (
    input          clk,
    input          rst_n,
    input  [7:0]   in,
    output reg [31:0] out
);
    reg [7:0] in_d;

    // Sign-extend 8-bit input to 32 bits by replicating the sign bit (MSB) 24 times
    wire [31:0] sign_extended = {{24{in[7]}}, in};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out  <= 32'b0;
            in_d <= 8'b0;
        end else if (in != in_d) begin
            // Update output only if input changes to reduce toggling and dynamic power
            out  <= sign_extended;
            in_d  <= in;
        end
    end
endmodule