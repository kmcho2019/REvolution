module instr_reg (
    input        clk,
    input        rst,       // active low reset
    input  [1:0] fetch,
    input  [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

    reg [7:0] ins_p1;  // instruction from source 1 (register)
    reg [7:0] ins_p2;  // instruction from source 2 (RAM/ROM)

    // Sequential logic for ins_p1 and ins_p2 with asynchronous active low reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            if (fetch == 2'b01)
                ins_p1 <= data;
            // else hold ins_p1

            if (fetch == 2'b10)
                ins_p2 <= data;
            // else hold ins_p2
        end
    end

    // Outputs
    assign ins = ins_p1[7:5];    // upper 3 bits from ins_p1
    assign ad1 = ins_p1[4:0];    // lower 5 bits from ins_p1
    assign ad2 = ins_p2;         // full 8 bits from ins_p2

endmodule