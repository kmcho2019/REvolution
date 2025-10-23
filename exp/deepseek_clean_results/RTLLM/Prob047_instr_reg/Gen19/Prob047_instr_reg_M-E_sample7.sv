module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // 16-bit shift register holding both instruction parts
    reg [15:0] shift_reg;
    
    // Control signals
    wire load_p1 = (fetch == 2'b01);
    wire load_p2 = (fetch == 2'b10);
    wire shift_en = (fetch == 2'b11); // Optional future feature
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_reg <= 16'b0;
        end else begin
            case ({load_p1, load_p2, shift_en})
                3'b100: shift_reg[15:8] <= data;  // Load part1
                3'b010: shift_reg[7:0] <= data;    // Load part2
                3'b001: shift_reg <= {shift_reg[7:0], shift_reg[15:8]}; // Circular shift
                default: shift_reg <= shift_reg;    // Hold value
            endcase
        end
    end
    
    // Output assignments (registered for better timing)
    always @(posedge clk) begin
        if (!rst) begin
            ins <= 3'b0;
            ad1 <= 5'b0;
            ad2 <= 8'b0;
        end else begin
            ins <= shift_reg[15:13];  // Top 3 bits of part1
            ad1 <= shift_reg[12:8];   // Lower 5 bits of part1
            ad2 <= shift_reg[7:0];    // Full part2
        end
    end

endmodule