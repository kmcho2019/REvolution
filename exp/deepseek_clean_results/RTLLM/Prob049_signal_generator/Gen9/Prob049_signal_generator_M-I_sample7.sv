module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// One-hot state encoding
localparam S_INC = 1'b0;
localparam S_DEC = 1'b1;
reg state;

// Gray code conversion
wire [4:0] gray_wave;
binary_to_gray bg(.binary(wave), .gray(gray_wave));

// Registered arithmetic
reg [4:0] next_wave;
always @(*) begin
    case (state)
        S_INC: next_wave = wave + 1'b1;
        S_DEC: next_wave = wave - 1'b1;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= S_INC;
    end else begin
        wave <= next_wave;
        
        // Immediate direction change at boundaries
        if ((state == S_INC) && (&wave)) begin
            state <= S_DEC;
        end else if ((state == S_DEC) && (wave == 5'b0)) begin
            state <= S_INC;
        end
    end
end

// Gray code converter module
module binary_to_gray(
    input [4:0] binary,
    output [4:0] gray
);
    assign gray = {binary[4], binary[4:1] ^ binary[3:0]};
endmodule

endmodule