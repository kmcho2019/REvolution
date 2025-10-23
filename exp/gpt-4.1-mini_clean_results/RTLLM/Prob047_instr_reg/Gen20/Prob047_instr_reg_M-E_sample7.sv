module instr_reg (
    input wire clk,
    input wire rst,          // active low reset
    input wire [1:0] fetch,
    input wire [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    reg [1:0] fetch_reg;
    reg [15:0] ins_packed; // {ins_p2, ins_p1}

    always @(posedge clk) begin
        if (!rst) begin
            ins_packed <= 16'b0;
            fetch_reg <= 2'b00;
        end else begin
            fetch_reg <= fetch;
            case (fetch)
                2'b01: ins_packed[7:0] <= data;       // update ins_p1
                2'b10: ins_packed[15:8] <= data;      // update ins_p2
                default: ins_packed <= ins_packed;    // hold value
            endcase
        end
    end

    // Outputs decoded from ins_packed
    assign ins = ins_packed[7:5];       // high 3 bits of ins_p1
    assign ad1 = ins_packed[4:0];       // low 5 bits of ins_p1
    assign ad2 = ins_packed[15:8];      // full ins_p2 data

endmodule