module TopModule(
    input       clk,         // clock
    input       resetn,      // active-low synchronous reset
    input       in,         // input to shift register
    output      out         // output of shift register
);

reg [3:0] reg_file;  // internal register file for DFFs

// Initialize the output
assign out = reg_file[3];

// Sequential logic for DFFs
always @(posedge clk) begin
    if (!resetn) begin  // synchronous active-low reset
        reg_file <= 4'b0000;
    end else begin
        reg_file <= {reg_file[2:0], in};  // shift in new data
    end
end

endmodule