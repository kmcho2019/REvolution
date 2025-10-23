module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
localparam IDLE  = 2'b00;
localparam GOT_1  = 2'b01;
localparam GOT_10 = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
        GOT_1: begin
            if (~x) begin
                next_state = GOT_10;
            end else begin
                next_state = GOT_1;
            end
        end
        GOT_10: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always_comb begin
    case (current_state)
        IDLE: z = 1'b0;
        GOT_1: z = 1'b0;
        GOT_10: z = x;
        default: z = 1'b0;
    endcase
end

endmodule