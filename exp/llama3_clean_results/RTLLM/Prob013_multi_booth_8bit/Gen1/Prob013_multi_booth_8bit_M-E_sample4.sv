module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [3:0] state;
reg [15:0] product;
reg [1:0] booth_encodings [3:0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        product <= 0;
        rdy <= 0;
    end else begin
        case (state)
            4'd0: begin
                // Calculate Booth encodings
                booth_encodings[0] <= b[1:0];
                booth_encodings[1] <= b[3:2];
                booth_encodings[2] <= b[5:4];
                booth_encodings[3] <= b[7:6];
                state <= 4'd1;
            end
            4'd1: begin
                // Perform multiplications in parallel
                product <= (a * (booth_encodings[0] == 2'b01 ? 1 : 
                              booth_encodings[0] == 2'b10 ? -1 : 0)) +
                           (a * (booth_encodings[1] == 2'b01 ? 1 : 
                              booth_encodings[1] == 2'b10 ? -1 : 0)) * 4 +
                           (a * (booth_encodings[2] == 2'b01 ? 1 : 
                              booth_encodings[2] == 2'b10 ? -1 : 0)) * 16 +
                           (a * (booth_encodings[3] == 2'b01 ? 1 : 
                              booth_encodings[3] == 2'b10 ? -1 : 0)) * 64;
                state <= 4'd2;
            end
            4'd2: begin
                // Output product and set ready signal
                p <= product;
                rdy <= 1;
                state <= 4'd3;
            end
            4'd3: begin
                // Wait for next operation
                if (!reset) begin
                    state <= 4'd0;
                end
            end
        endcase
    end
end

endmodule