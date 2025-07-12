module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

    // One-hot counter: 12 bits, each representing count from 0 to 11
    reg [11:0] one_hot_count;
    reg        enable_d;

    // Register the enable signal to avoid glitches in combinational logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            enable_d <= 1'b0;
        else
            enable_d <= valid_count;
    end

    // One-hot counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            one_hot_count <= 12'b0000_0000_0001;  // count = 0
        else if (enable_d) begin
            // Rotate one-hot to next count state, wrapping after count 11
            if (one_hot_count == 12'b1000_0000_0000) 
                one_hot_count <= 12'b0000_0000_0001; // wrap to count 0
            else
                one_hot_count <= one_hot_count << 1;
        end
        // else hold the current state
    end

    // Decode one-hot count to binary output
    always @(*) begin
        casex (one_hot_count)
            12'b0000_0000_0001 : out = 4'd0;
            12'b0000_0000_0010 : out = 4'd1;
            12'b0000_0000_0100 : out = 4'd2;
            12'b0000_0000_1000 : out = 4'd3;
            12'b0000_0001_0000 : out = 4'd4;
            12'b0000_0010_0000 : out = 4'd5;
            12'b0000_0100_0000 : out = 4'd6;
            12'b0000_1000_0000 : out = 4'd7;
            12'b0001_0000_0000 : out = 4'd8;
            12'b0010_0000_0000 : out = 4'd9;
            12'b0100_0000_0000 : out = 4'd10;
            12'b1000_0000_0000 : out = 4'd11;
            default            : out = 4'd0; // Safe default (should never happen)
        endcase
    end

endmodule