module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [7:0] shift_reg;      // Holds last 8 bits of input stream
    reg [2:0] one_count;      // Count consecutive ones (saturate at 7)
    
    // Intermediate signals for output detection
    wire disc_w;
    wire flag_w;
    wire err_w;

    // Update consecutive ones count
    always @(posedge clk) begin
        if (reset) begin
            one_count <= 3'd0;
        end else begin
            if (in == 1'b1) begin
                if (one_count < 3'd7)
                    one_count <= one_count + 3'd1;
                else
                    one_count <= 3'd7;  // Saturate at 7
            end else begin
                one_count <= 3'd0;
            end
        end
    end

    // Shift input bit into shift register each clock
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], in};
        end
    end

    // Pattern detection combinational logic
    // For disc (bit to discard): pattern is 0111110 -> bits [6:1] == 6'b0111110
    //   means: shift_reg[6:1] == 6'b0111110
    // For flag: full 8 bits == 01111110 (0x7E)
    // For err: consecutive ones count saturated at 7

    assign disc_w = (shift_reg[6:1] == 6'b0111110);
    assign flag_w = (shift_reg == 8'b01111110);
    assign err_w  = (one_count == 3'd7);

    // Register outputs, asserted one cycle after condition occurs (Moore FSM style)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= disc_w;
            flag <= flag_w;
            err  <= err_w;
        end
    end

endmodule