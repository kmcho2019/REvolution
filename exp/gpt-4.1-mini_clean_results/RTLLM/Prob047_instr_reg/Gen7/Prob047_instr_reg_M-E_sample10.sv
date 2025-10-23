module instr_reg (
    input  wire        clk,
    input  wire        rst,    // active low reset
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // ins_p1 register: synchronous reset, update if fetch == 2'b01
    always @(posedge clk) begin
        if (!rst)
            ins_p1 <= 8'b0;
        else if (fetch == 2'b01)
            ins_p1 <= data;
        else
            ins_p1 <= ins_p1;
    end

    // ins_p2 register: synchronous reset, update if fetch == 2'b10
    always @(posedge clk) begin
        if (!rst)
            ins_p2 <= 8'b0;
        else if (fetch == 2'b10)
            ins_p2 <= data;
        else
            ins_p2 <= ins_p2;
    end

    // Continuous assignments for outputs
    assign ins = ins_p1[7:5];  // upper 3 bits of ins_p1
    assign ad1 = ins_p1[4:0];  // lower 5 bits of ins_p1
    assign ad2 = ins_p2;       // entire 8 bits of ins_p2

endmodule