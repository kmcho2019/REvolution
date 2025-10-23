module TopModule #(
    parameter DATA_WIDTH = 4,
    parameter SEL_WIDTH = 3
) (
    input [SEL_WIDTH-1:0] sel,
    input [5:0][DATA_WIDTH-1:0] data,  // Packed array for all data inputs
    output reg [DATA_WIDTH-1:0] out
);

// synthesis translate_off
initial $display("Mux %m: DATA_WIDTH=%0d, SEL_WIDTH=%0d", DATA_WIDTH, SEL_WIDTH);
// synthesis translate_on

always @(*) begin
    casez (sel)  // casez allows potential optimization of don't-care bits
        3'b000: out = data[0];
        3'b001: out = data[1];
        3'b010: out = data[2];
        3'b011: out = data[3];
        3'b100: out = data[4];
        3'b101: out = data[5];
        default: out = {DATA_WIDTH{1'b0}};  // Replicated zero for parameterized width
    endcase
end

// synthesis attribute ram_style of out is distributed
// synthesis attribute use_dsp48 of out is no

endmodule