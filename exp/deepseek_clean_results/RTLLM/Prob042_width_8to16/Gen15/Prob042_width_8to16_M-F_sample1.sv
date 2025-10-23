module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Expanded state encoding for better synthesis
localparam [1:0] IDLE      = 2'b00;
localparam [1:0] GOT_FIRST = 2'b01;

reg [1:0] state, next_state;
reg [7:0] first_byte_reg;

// Combinational next state logic
always @(*) begin
    next_state = state; // Default: stay in current state
    case (state)
        IDLE: 
            if (valid_in) 
                next_state = GOT_FIRST;
        GOT_FIRST: 
            if (valid_in) 
                next_state = IDLE;
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        state <= next_state;
        
        // Store first byte when valid in IDLE state
        if (valid_in && state == IDLE)
            first_byte_reg <= data_in;
            
        // Generate output when valid in GOT_FIRST state
        valid_out <= 1'b0;
        if (valid_in && state == GOT_FIRST) begin
            data_out <= {first_byte_reg, data_in};
            valid_out <= 1'b1;
        end
    end
end

endmodule