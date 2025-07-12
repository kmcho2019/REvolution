module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
typedef enum logic [1:0] {
    IDLE,
    FIRST_BYTE,
    OUTPUT
} state_t;

// State and data registers
state_t state;
reg [7:0] stored_byte;

// State machine and data storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_byte <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    stored_byte <= data_in;
                    state <= FIRST_BYTE;
                end
            end
            
            FIRST_BYTE: begin
                if (valid_in) begin
                    data_out <= {stored_byte, data_in};
                    state <= OUTPUT;
                end
            end
            
            OUTPUT: begin
                state <= IDLE;
            end
        endcase
    end
end

// Output generation (registered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
    end else begin
        valid_out <= (state == OUTPUT);
    end
end

endmodule