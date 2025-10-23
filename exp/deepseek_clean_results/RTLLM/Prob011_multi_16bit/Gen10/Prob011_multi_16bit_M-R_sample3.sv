module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// State encoding
localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam CALC = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [3:0] bit_pos;  // Only need 4 bits for 0-15
reg [15:0] areg;
reg [31:0] shifted_b [15:0];  // Pre-shifted versions of breg
reg [31:0] product;

// Generate all possible shifted versions of bin
integer j;
always @(*) begin
    for (j = 0; j < 16; j = j + 1) begin
        shifted_b[j] = bin << j;
    end
end

// State machine and calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_pos <= 4'b0;
        areg <= 16'b0;
        product <= 32'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= LOAD;
                    bit_pos <= 4'b0;
                end
            end
            
            LOAD: begin
                areg <= ain;
                product <= 32'b0;
                state <= CALC;
                bit_pos <= 4'b0;
            end
            
            CALC: begin
                if (areg[bit_pos]) begin
                    product <= product + shifted_b[bit_pos];
                end
                
                if (bit_pos == 4'b1111) begin
                    state <= DONE;
                end
                else begin
                    bit_pos <= bit_pos + 1;
                end
            end
            
            DONE: begin
                if (!start) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output assignments
assign done = (state == DONE);
always @(*) begin
    yout = (state == DONE) ? product : 32'b0;
end

endmodule