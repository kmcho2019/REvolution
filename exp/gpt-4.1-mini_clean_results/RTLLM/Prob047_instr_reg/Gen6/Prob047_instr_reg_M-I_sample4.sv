module instr_reg (
    input         clk,
    input         rst,    // active low reset
    input  [1:0]  fetch,
    input  [7:0]  data,
    output [2:0]  ins,
    output [4:0]  ad1,
    output [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01)
                ins_p1 <= data;
            if (fetch == 2'b10)
                ins_p2 <= data;
            // No else needed; registers hold their values otherwise
        end
    end

    assign ins = ins_p1[7:5];  // High 3 bits
    assign ad1 = ins_p1[4:0];  // Low 5 bits
    assign ad2 = ins_p2;       // Full 8 bits

endmodule