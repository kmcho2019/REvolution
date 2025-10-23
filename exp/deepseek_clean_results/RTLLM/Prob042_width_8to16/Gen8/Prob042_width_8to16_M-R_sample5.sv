module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
localparam WAIT_FIRST = 1'b0;
localparam WAIT_SECOND = 1'b1;

reg state;
reg [7:0] first_byte;
reg has_first_byte;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= WAIT_FIRST;
        first_byte <= 8'b0;
        has_first_byte <= 1'b0;
    end else begin
        if (valid_in) begin
            case (state)
                WAIT_FIRST: begin
                    first_byte <= data_in;
                    has_first_byte <= 1'b1;
                    state <= WAIT_SECOND;
                end
                WAIT_SECOND: begin
                    state <= WAIT_FIRST;
                end
            endcase
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= (state == WAIT_SECOND) && valid_in;
        if ((state == WAIT_SECOND) && valid_in) begin
            data_out <= {first_byte, data_in};
        end
    end
end

endmodule