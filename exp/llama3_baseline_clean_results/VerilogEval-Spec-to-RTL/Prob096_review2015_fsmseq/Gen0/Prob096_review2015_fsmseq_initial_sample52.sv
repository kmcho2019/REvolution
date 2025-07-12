module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
localparam IDLE = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0011;
localparam FOUND = 4'b0100;

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (!data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == FOUND || next_state == FOUND) begin
            start_shifting <= 1;
        end
    end
end

endmodule