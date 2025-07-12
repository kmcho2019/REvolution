module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
localparam IDLE = 1'b0;
localparam GOT_FIRST = 1'b1;

reg state;
reg [7:0] stored_byte;

// Next state and storage logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_byte <= 8'b0;
    end else begin
        case (state)
            IDLE: if (valid_in) begin
                stored_byte <= data_in;
                state <= GOT_FIRST;
            end
            GOT_FIRST: if (valid_in) begin
                state <= IDLE;
            end
        endcase
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= (state == GOT_FIRST) && valid_in;
        if ((state == GOT_FIRST) && valid_in) begin
            data_out <= {stored_byte, data_in};
        end
    end
end

endmodule