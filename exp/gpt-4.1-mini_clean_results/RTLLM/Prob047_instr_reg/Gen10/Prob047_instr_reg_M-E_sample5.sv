module instr_reg (
    input  wire        clk,
    input  wire        rst,    // synchronous active high reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // ins_p1 update: synchronous reset and enable when fetch == 2'b01
    always @(posedge clk) begin
        if (rst) begin
            ins_p1 <= 8'b0;
        end else if (fetch == 2'b01) begin
            ins_p1 <= data;
        end
        // else retain current value
    end

    // ins_p2 update: synchronous reset and enable when fetch == 2'b10
    always @(posedge clk) begin
        if (rst) begin
            ins_p2 <= 8'b0;
        end else if (fetch == 2'b10) begin
            ins_p2 <= data;
        end
        // else retain current value
    end

    // Outputs derived from ins_p1 and ins_p2
    assign ins = ins_p1[7:5];   // opcode: upper 3 bits
    assign ad1 = ins_p1[4:0];   // register address: lower 5 bits
    assign ad2 = ins_p2;        // full 8-bit data from second source

endmodule