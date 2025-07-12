module instr_reg (
    input wire        clk,
    input wire        rst,    // active low reset
    input wire [1:0]  fetch,
    input wire [7:0]  data,
    output reg [2:0]  ins,
    output reg [4:0]  ad1,
    output reg [7:0]  ad2
);

    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Instruction registers update
    always @(posedge clk) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end else begin
            case(fetch)
                2'b01: ins_p1 <= data;
                2'b10: ins_p2 <= data;
                default: begin
                    ins_p1 <= ins_p1;
                    ins_p2 <= ins_p2;
                end
            endcase
        end
    end

    // Registered outputs for stable timing and glitch-free operation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            // ins and ad1 always come from ins_p1
            ins <= ins_p1[7:5];
            ad1 <= ins_p1[4:0];
            // ad2 outputs ins_p2 when fetch==2'b10, else zero
            ad2 <= (fetch == 2'b10) ? ins_p2 : 8'b0;
        end
    end

endmodule