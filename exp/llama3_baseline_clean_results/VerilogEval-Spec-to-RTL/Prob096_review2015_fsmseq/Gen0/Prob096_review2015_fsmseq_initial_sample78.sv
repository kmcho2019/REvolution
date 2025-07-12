module TopModule(
    input        clk,
    input        reset,
    input        data,
    output       start_shifting
);

// Define states
localparam IDLE     = 4'b0001;
localparam FOUND_1  = 4'b0010;
localparam FOUND_11 = 4'b0100;
localparam FOUND_110 = 4'b1000;

reg [3:0] current_state;
reg [3:0] next_state;

always @(*) begin
    case (current_state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = FOUND_1;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND_1: begin
            if (data == 1'b1) begin
                next_state = FOUND_11;
            end else if (data == 1'b0) begin
                next_state = IDLE;
            end else begin
                next_state = FOUND_1;
            end
        end
        FOUND_11: begin
            if (data == 1'b0) begin
                next_state = FOUND_110;
            end else begin
                next_state = FOUND_1;
            end
        end
        FOUND_110: begin
            if (data == 1'b1) begin
                next_state = FOUND_110;
            end else begin
                next_state = FOUND_110;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        IDLE: start_shifting = 1'b0;
        FOUND_1: start_shifting = 1'b0;
        FOUND_11: start_shifting = 1'b0;
        FOUND_110: start_shifting = 1'b1;
        default: start_shifting = 1'b0;
    endcase
end

endmodule