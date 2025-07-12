module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine definitions
    localparam IDLE = 2'b00;
    localparam BOOTH = 2'b01;
    localparam WALLACE = 2'b10;
    localparam FINAL = 2'b11;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [31:0] partial_products [0:8];
    reg [31:0] wallace_out;
    reg [31:0] final_result;
    reg done_next;

    // Booth encoder
    function [31:0] booth_encoder;
        input [15:0] b;
        input [15:0] a;
        integer i;
        begin
            booth_encoder = 32'b0;
            for (i = 0; i < 9; i = i + 1) begin
                case (b[i*2 +: 3])
                    3'b000, 3'b111: partial_products[i] = 32'b0;
                    3'b001, 3'b010: partial_products[i] = {{16{a[15]}}, a} << (i*2);
                    3'b011:         partial_products[i] = {{15{a[15]}}, a, 1'b0} << (i*2);
                    3'b100:         partial_products[i] = -{{15{a[15]}}, a, 1'b0} << (i*2);
                    3'b101, 3'b110: partial_products[i] = -{{16{a[15]}}, a} << (i*2);
                endcase
            end
        end
    endfunction

    // Wallace tree 4:2 compressor
    function [31:0] wallace_reduction;
        input [31:0] pp [0:8];
        integer i;
        reg [31:0] sum, carry;
        begin
            sum = pp[0];
            carry = 32'b0;
            for (i = 1; i < 9; i = i + 1) begin
                sum = sum ^ pp[i] ^ carry;
                carry = (sum & pp[i]) | (sum & carry) | (pp[i] & carry);
            end
            wallace_reduction = sum + (carry << 1);
        end
    endfunction

    // Kogge-Stone parallel prefix adder
    function [31:0] kogge_stone;
        input [31:0] a, b;
        reg [31:0] p, g;
        integer i;
        begin
            p = a ^ b;
            g = a & b;
            
            // Prefix computation
            for (i = 0; i < 5; i = i + 1) begin
                g = g | (p & (g << (1 << i)));
                p = p & (p << (1 << i));
            end
            
            kogge_stone = p ^ (g << 1);
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            multiplicand <= 16'b0;
            final_result <= 32'b0;
            done <= 1'b0;
            done_next <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= ain;
                        state <= BOOTH;
                    end
                    done <= 1'b0;
                end
                
                BOOTH: begin
                    booth_encoder(bin, multiplicand);
                    state <= WALLACE;
                end
                
                WALLACE: begin
                    wallace_out <= wallace_reduction(partial_products);
                    state <= FINAL;
                end
                
                FINAL: begin
                    final_result <= kogge_stone(wallace_out, 32'b0);
                    state <= IDLE;
                    done_next <= 1'b1;
                end
            endcase
            
            // Pipeline the done signal
            done <= done_next;
            done_next <= 1'b0;
        end
    end

    always @(*) begin
        yout = final_result;
    end

endmodule