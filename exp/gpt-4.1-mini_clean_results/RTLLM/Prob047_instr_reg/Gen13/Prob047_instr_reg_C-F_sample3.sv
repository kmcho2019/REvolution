module instr_reg (
    input  wire        clk,
    input  wire        rst,    // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;  // Instruction register for fetch==01
    reg [7:0] ins_p2;  // Instruction register for fetch==10

    // Asynchronous active-low reset, update ins_p1 and ins_p2 on clk edge based on fetch
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            if (fetch == 2'b10) begin
                ins_p2 <= data;
            end
            // If fetch is neither 01 nor 10, retain previous values
        end
    end

    // Outputs extracted directly from respective registers
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule