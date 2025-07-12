module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    reg [7:0] ins_p1, ins_p2;
    reg clk_gate;
    reg [1:0] fetch_reg;

    // Clock gating logic
    always @(*) begin
        clk_gate = |fetch;  // Only enable clock when fetch is active
    end

    // Register update logic with clock gating
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
            fetch_reg <= 2'b0;
        end else if (clk_gate) begin
            fetch_reg <= fetch;
            if (fetch[0]) ins_p1 <= data;
            if (fetch[1]) ins_p2 <= data;
        end
    end

    // Output pipeline registers
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            ad2 <= ins_p2;
        end
    end

endmodule