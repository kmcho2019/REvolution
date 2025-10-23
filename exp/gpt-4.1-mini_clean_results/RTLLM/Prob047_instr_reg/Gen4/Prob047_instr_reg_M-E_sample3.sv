module instr_reg (
    input  wire        clk,
    input  wire        rst,   // active low
    input  wire [1:0]  fetch,
    input  wire [7:0]  data,
    output wire [2:0]  ins,
    output wire [4:0]  ad1,
    output wire [7:0]  ad2
);

    reg [7:0] reg_bank [1:0]; // 0: ins_p1, 1: ins_p2

    always @(posedge clk) begin
        if (!rst) begin
            reg_bank[0] <= 8'd0;
            reg_bank[1] <= 8'd0;
        end else begin
            case (fetch)
                2'b01: reg_bank[0] <= data;
                2'b10: reg_bank[1] <= data;
                default: begin
                    // retain previous values
                    reg_bank[0] <= reg_bank[0];
                    reg_bank[1] <= reg_bank[1];
                end
            endcase
        end
    end

    assign ins = reg_bank[0][7:5];
    assign ad1 = reg_bank[0][4:0];
    assign ad2 = reg_bank[1];

endmodule