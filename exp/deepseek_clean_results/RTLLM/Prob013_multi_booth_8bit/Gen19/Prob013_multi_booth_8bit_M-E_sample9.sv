module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_multiplicand;
    reg [15:0] stage1_pp; // partial product
    reg [2:0] stage1_booth; // booth encoding
    reg stage1_valid;
    
    reg [15:0] accumulator;
    reg [3:0] counter;
    reg early_term;
    
    // Booth encoding function
    function [15:0] booth_pp;
        input [15:0] m;
        input [2:0] enc;
        begin
            case (enc[1:0])
                2'b01: booth_pp = m;
                2'b10: booth_pp = ~m + 1; // -m
                2'b11: booth_pp = {m[14:0], 1'b0}; // 2m
                default: booth_pp = 0;
            endcase
        end
    endfunction

    // Stage 1: Booth encoding
    always @(posedge clk) begin
        if (reset) begin
            stage1_multiplicand <= {{8{a[7]}}, a};
            stage1_booth <= {b[1:0], 1'b0};
            stage1_valid <= 1'b1;
            early_term <= (a == 0 || b == 0 || b == 8'hFF);
            counter <= 0;
        end else if (!rdy) begin
            if (early_term) begin
                p <= (b == 0) ? 0 : 
                    (b == 8'hFF) ? {{8{a[7]}}, a} : p;
                rdy <= 1'b1;
            end else begin
                stage1_booth <= {b[2*counter+3:2*counter+2], b[2*counter+1]};
                stage1_multiplicand <= stage1_multiplicand << 2;
                stage1_pp <= booth_pp(stage1_multiplicand, stage1_booth);
                stage1_valid <= (counter < 4);
                
                if (counter == 4) begin
                    rdy <= 1'b1;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

    // Stage 2: Accumulation
    always @(posedge clk) begin
        if (reset) begin
            accumulator <= 0;
            p <= 0;
        end else if (stage1_valid && !rdy) begin
            // Carry-save addition
            {accumulator, p} <= {1'b0, accumulator + stage1_pp + p};
        end
    end

endmodule