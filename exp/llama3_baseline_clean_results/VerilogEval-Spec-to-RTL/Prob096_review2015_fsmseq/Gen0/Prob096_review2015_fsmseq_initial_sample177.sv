module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state;

// Define states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam FOUND = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data == 1) begin
                    state <= S1;
                end else if (data == 0) begin
                    state <= S2;
                end
            end
            S2: begin
                if (data == 1) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data == 1) begin
                    state <= IDLE;
                end else if (data == 0) begin
                    state <= FOUND;
                end
            end
            FOUND: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule