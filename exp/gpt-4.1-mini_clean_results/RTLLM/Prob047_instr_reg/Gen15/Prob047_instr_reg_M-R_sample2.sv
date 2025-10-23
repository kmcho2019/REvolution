module instr_reg (
    input  wire       clk,
    input  wire       rst,      // Active low reset
    input  wire [1:0] fetch,
    input  wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Update ins_p1 when fetch == 2'b01
    always @(posedge clk or negedge rst) begin
        if (!rst)
            ins_p1 <= 8'b0;
        else if (fetch == 2'b01)
            ins_p1 <= data;
        else
            ins_p1 <= ins_p1; // retain previous value
    end

    // Update ins_p2 when fetch == 2'b10
    always @(posedge clk or negedge rst) begin
        if (!rst)
            ins_p2 <= 8'b0;
        else if (fetch == 2'b10)
            ins_p2 <= data;
        else
            ins_p2 <= ins_p2; // retain previous value
    end

    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule