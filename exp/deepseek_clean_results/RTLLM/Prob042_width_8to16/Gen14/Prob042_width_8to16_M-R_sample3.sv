module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State encoding
localparam IDLE = 1'b0;
localparam GOT_FIRST = 1'b1;

reg state, next_state;
reg [7:0] first_byte_reg;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = valid_in ? GOT_FIRST : IDLE;
        GOT_FIRST: next_state = valid_in ? IDLE : GOT_FIRST;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        state <= next_state;
        
        // Store first byte when transitioning to GOT_FIRST
        if (valid_in && state == IDLE)
            first_byte_reg <= data_in;
            
        // Generate output when getting second byte
        valid_out <= 1'b0;
        if (valid_in && state == GOT_FIRST) begin
            data_out <= {first_byte_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule