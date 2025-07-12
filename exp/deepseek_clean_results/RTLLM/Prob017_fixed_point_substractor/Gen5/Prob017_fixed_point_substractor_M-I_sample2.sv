module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire clk,      // Clock
    input wire en,       // Enable signal
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Stage 1 registers
    reg [N-1:0] a_abs, b_abs;
    reg a_sign, b_sign;
    
    // Stage 2 registers
    reg [N-1:0] result;
    
    // Combinational logic for absolute values
    wire [N-1:0] a_abs_w = a[N-1] ? -a : a;
    wire [N-1:0] b_abs_w = b[N-1] ? -b : b;
    
    // Stage 1: Register absolute values and signs
    always @(posedge clk) if (en) begin
        a_sign <= a[N-1];
        b_sign <= b[N-1];
        a_abs <= a_abs_w;
        b_abs <= b_abs_w;
    end
    
    // Stage 2: Compute result
    always @(posedge clk) if (en) begin
        if (a_sign == b_sign) begin
            // Parallel magnitude comparison
            if (a_abs > b_abs) begin
                result <= {a_sign, (a_abs - b_abs)[N-2:0]};
            end else begin
                result <= {~a_sign, (b_abs - a_abs)[N-2:0]};
            end
        end else begin
            // Different signs - perform addition
            result <= {a_sign, (a_abs + b_abs)[N-2:0]};
        end
        
        // Zero detection and correction
        if (result[N-2:0] == 0) result[N-1] <= 0;
    end
    
    // Output assignment
    always @(posedge clk) if (en) begin
        c <= result;
    end

endmodule