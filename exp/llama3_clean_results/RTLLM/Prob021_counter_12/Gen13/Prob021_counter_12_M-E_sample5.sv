module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [1:0] state;  // State register (idle, counting)
logic [3:0] count;  // Counter register

// One-hot encoding for states
localparam IDLE = 2'b01;
localparam COUNTING = 2'b10;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        count <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (valid_count) begin
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (!valid_count) begin
                    state <= IDLE;
                end else begin
                    count <= count + 1;
                    if (count == 4'd11) begin
                        count <= 4'b0000;
                    end
                end
            end
            default: begin
                state <= IDLE;
                count <= 4'b0000;
            end
        endcase
    end
end

assign out = count;

endmodule