module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State machine states
typedef enum logic {
    WAIT_FIRST,
    WAIT_SECOND
} state_t;

reg state;
reg [7:0] stored_data;

// Output assignments (combinational)
assign valid_out = (state == WAIT_SECOND) && valid_in;
assign data_out = {stored_data, data_in};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= WAIT_FIRST;
        stored_data <= 8'b0;
    end else begin
        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    stored_data <= data_in;
                    state <= WAIT_SECOND;
                end
            end
            
            WAIT_SECOND: begin
                if (valid_in) begin
                    // After output is generated, return to waiting for first byte
                    state <= WAIT_FIRST;
                end
            end
        endcase
    end
end

endmodule