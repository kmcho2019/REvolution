// Define an enumeration for the states
enum logic [1:0] {IDLE, STAGE1, STAGE2, STAGE3} state, next_state;

// 16-bit adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

    assign sum = a + b + cin;
    assign cout = (a[15] & b[15]) | (a[15] & cin) | (b[15] & cin);

endmodule

// 64-bit pipelined adder module
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

    reg [15:0] sum_reg [3:0];
    reg cout_reg [3:0];
    reg [15:0] adda_reg [3:0];
    reg [15:0] addb_reg [3:0];

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            o_en <= 1'b0;
            sum_reg <= '{default: 16'd0};
            cout_reg <= '{default: 1'b0};
            adda_reg <= '{default: 16'd0};
            addb_reg <= '{default: 16'd0};
        end else begin
            state <= next_state;
            if (next_state == STAGE3) begin
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (i_en) begin
                    next_state = STAGE1;
                end else begin
                    next_state = IDLE;
                end
            end
            STAGE1: begin
                next_state = STAGE2;
            end
            STAGE2: begin
                next_state = STAGE3;
            end
            STAGE3: begin
                next_state = IDLE;
            end
        endcase
    end

    // Combinational logic for each stage
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (i_en) begin
                    adda_reg[0] <= adda[15:0];
                    addb_reg[0] <= addb[15:0];
                    adda_reg[1] <= adda[31:16];
                    addb_reg[1] <= addb[31:16];
                    adda_reg[2] <= adda[47:32];
                    addb_reg[2] <= addb[47:32];
                    adda_reg[3] <= adda[63:48];
                    addb_reg[3] <= addb[63:48];
                end
            end
            STAGE1: begin
                adder_16bit u_adder1(.a(adda_reg[0]),.b(addb_reg[0]),.cin(1'b0),.sum(sum_reg[0]),.cout(cout_reg[0]));
            end
            STAGE2: begin
                adder_16bit u_adder2(.a(adda_reg[1]),.b(addb_reg[1]),.cin(cout_reg[0]),.sum(sum_reg[1]),.cout(cout_reg[1]));
            end
            STAGE3: begin
                adder_16bit u_adder3(.a(adda_reg[2]),.b(addb_reg[2]),.cin(cout_reg[1]),.sum(sum_reg[2]),.cout(cout_reg[2]));
                adder_16bit u_adder4(.a(adda_reg[3]),.b(addb_reg[3]),.cin(cout_reg[2]),.sum(sum_reg[3]),.cout(cout_reg[3]));
            end
        endcase
    end

    // Continuous assignment for result
    assign result = {cout_reg[3], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};

endmodule