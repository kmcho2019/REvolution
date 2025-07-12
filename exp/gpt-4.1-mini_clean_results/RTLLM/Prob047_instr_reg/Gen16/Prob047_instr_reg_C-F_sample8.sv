module instr_reg(
    input        clk,
    input        rst,    // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Two separate registers to hold instructions from different sources
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            // Reset outputs too
            ins    <= 3'b0;
            ad1    <= 5'b0;
            ad2    <= 8'b0;
        end else begin
            // Update ins_p1 if fetch == 2'b01
            if (fetch == 2'b01) begin
                ins_p1 <= data;
            end
            // Update ins_p2 if fetch == 2'b10
            else if (fetch == 2'b10) begin
                ins_p2 <= data;
            end

            // Register outputs on every clock cycle for timing stability
            // ins and ad1 come from ins_p1
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            // ad2 comes from ins_p2
            ad2 <= ins_p2;
        end
    end

endmodule