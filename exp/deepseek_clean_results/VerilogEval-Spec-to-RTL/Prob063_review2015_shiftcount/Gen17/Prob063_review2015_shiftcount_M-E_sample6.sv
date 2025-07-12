module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Internal registers
reg [3:0] shift_reg;
reg [3:0] count_reg;
reg [1:0] state;

// Gray code conversion functions
function [3:0] binary_to_gray;
    input [3:0] binary;
    binary_to_gray = binary ^ (binary >> 1);
endfunction

function [3:0] gray_to_binary;
    input [3:0] gray;
    gray_to_binary = {gray[3], 
                     gray[3] ^ gray[2],
                     gray[3] ^ gray[2] ^ gray[1],
                     gray[3] ^ gray[2] ^ gray[1] ^ gray[0]};
endfunction

// FSM states
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;

// Clock gating logic
wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    case (state)
        IDLE: begin
            if (shift_ena) begin
                state <= SHIFT;
                shift_reg <= {shift_reg[2:0], data};
            end
            else if (count_ena) begin
                state <= COUNT;
                count_reg <= binary_to_gray(gray_to_binary(count_reg) - 1);
            end
        end
        
        SHIFT: begin
            if (shift_ena) begin
                shift_reg <= {shift_reg[2:0], data};
            end
            else begin
                state <= IDLE;
            end
        end
        
        COUNT: begin
            if (count_ena) begin
                count_reg <= binary_to_gray(gray_to_binary(count_reg) - 1);
            end
            else begin
                state <= IDLE;
            end
        end
    endcase
end

// Output selection
always @(*) begin
    case (state)
        SHIFT: q = shift_reg;
        COUNT: q = gray_to_binary(count_reg);
        default: q = shift_reg; // Default to shift register output
    endcase
end

endmodule