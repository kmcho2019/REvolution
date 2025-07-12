module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Gray-coded state machine
    localparam [2:0] 
        IDLE = 3'b000,
        LOAD = 3'b001,
        CALC = 3'b011,
        DONE = 3'b010;

    reg [2:0] state;
    reg [15:0] areg;       // Rotating multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] acc;        // Accumulator
    reg [4:0] count;       // Gray-coded counter
    reg early_term;        // Early termination flag

    // Gray code increment function
    function [4:0] gray_inc;
        input [4:0] gray;
        reg [4:0] bin;
        begin
            // Convert gray to binary
            bin[4] = gray[4];
            bin[3] = gray[3] ^ bin[4];
            bin[2] = gray[2] ^ bin[3];
            bin[1] = gray[1] ^ bin[2];
            bin[0] = gray[0] ^ bin[1];
            
            // Increment binary
            bin = bin + 1;
            
            // Convert back to gray
            gray_inc[4] = bin[4];
            gray_inc[3] = bin[4] ^ bin[3];
            gray_inc[2] = bin[3] ^ bin[2];
            gray_inc[1] = bin[2] ^ bin[1];
            gray_inc[0] = bin[1] ^ bin[0];
        end
    endfunction

    // Parallel prefix adder (Brent-Kung)
    function [31:0] brent_kung_add;
        input [31:0] a, b;
        reg [31:0] sum;
        reg [31:0] g, p;
        integer i;
        begin
            // Pre-processing
            for (i = 0; i < 32; i = i + 1) begin
                g[i] = a[i] & b[i];
                p[i] = a[i] ^ b[i];
            end

            // Prefix computation
            for (i = 1; i < 32; i = i + 1) begin
                g[i] = g[i] | (p[i] & g[i-1]);
                p[i] = p[i] & p[i-1];
            end

            // Post-processing
            sum[0] = p[0];
            for (i = 1; i < 32; i = i + 1) begin
                sum[i] = p[i] ^ g[i-1];
            end

            brent_kung_add = sum;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            count <= 5'b00000;
            early_term <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= LOAD;
                        early_term <= 1'b0;
                    end
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 5'b00000;
                    state <= CALC;
                end
                
                CALC: begin
                    // Check for early termination
                    if (areg == 16'b0) begin
                        early_term <= 1'b1;
                        state <= DONE;
                    end else if (count[4]) begin // Count == 16 in gray code
                        state <= DONE;
                    end else begin
                        // Rotate areg and check LSB
                        if (areg[0]) begin
                            acc <= brent_kung_add(acc, {16'b0, breg} << count);
                        end
                        
                        // Rotate areg right
                        areg <= {1'b0, areg[15:1]};
                        
                        // Increment gray counter
                        count <= gray_inc(count);
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign yout = acc;
    assign done = (state == DONE);

endmodule