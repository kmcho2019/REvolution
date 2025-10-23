module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;      // input from cycle n-1
    reg [31:0] current_in;   // input from cycle n
    reg [31:0] captured;     // sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            current_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Pipeline the input values
            prev_in <= current_in;
            current_in <= in;
            
            // Detect falling edges between prev_in and current_in
            // and set the corresponding captured bits
            captured <= captured | (prev_in & ~current_in);
        end
    end

    assign out = captured;

endmodule