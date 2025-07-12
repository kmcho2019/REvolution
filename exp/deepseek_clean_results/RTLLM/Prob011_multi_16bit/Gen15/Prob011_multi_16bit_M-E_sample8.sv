module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [2:0] count;
    reg [15:0] areg;
    reg [16:0] breg;  // Extra bit for sign extension
    reg [31:0] acc;
    reg running;

    // Booth encoding cases
    wire [2:0] booth_bits;
    wire [31:0] booth_mux_out;
    wire [31:0] a_neg;
    wire [31:0] a_pos;
    wire [31:0] a2_pos;
    wire [31:0] a2_neg;

    assign a_pos = {16'b0, areg};
    assign a_neg = -a_pos;
    assign a2_pos = a_pos << 1;
    assign a2_neg = -a2_pos;

    // Current Booth encoding window
    assign booth_bits = (count == 0) ? {bin[1:0], 1'b0} : breg[2:0];

    // Booth multiplexer
    assign booth_mux_out = (booth_bits == 3'b000 || booth_bits == 3'b111) ? 32'b0 :
                          (booth_bits == 3'b001 || booth_bits == 3'b010) ? a_pos :
                          (booth_bits == 3'b011) ? a2_pos :
                          (booth_bits == 3'b100) ? a2_neg :
                          (booth_bits == 3'b101 || booth_bits == 3'b110) ? a_neg : 32'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'b0;
            areg <= 16'b0;
            breg <= 17'b0;
            acc <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize operation
                areg <= ain;
                breg <= {bin, 1'b0};  // Pad with 0 for first Booth window
                acc <= 32'b0;
                count <= 3'b0;
                done <= 1'b0;
                running <= 1'b1;
            end else if (running) begin
                // Booth accumulation
                acc <= acc + booth_mux_out;
                
                // Shift multiplier right by 2 bits
                breg <= {2'b0, breg[16:2]};
                
                // Update counter and check completion
                if (count == 3'd7 || (|breg[16:2] == 1'b0 && count != 0)) begin
                    // Early termination if remaining bits are zero
                    yout <= acc + booth_mux_out;
                    done <= 1'b1;
                    running <= 1'b0;
                end else begin
                    count <= count + 1;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule