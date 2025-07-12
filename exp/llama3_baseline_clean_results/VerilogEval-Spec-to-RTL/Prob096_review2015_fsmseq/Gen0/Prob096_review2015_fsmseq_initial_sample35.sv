module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // state register with 3 bits (8 possible states)

// define states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam FOUND = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        // reset state machine
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= S1;
                end
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= IDLE; // reset to IDLE on '0'
                end
            end
            S2: begin
                if (~data) begin
                    state <= S3;
                end else begin
                    state <= S1; // stay at '1' on another '1'
                end
            end
            S3: begin
                if (data) begin
                    state <= FOUND;
                end else begin
                    state <= IDLE; // reset to IDLE on another '0'
                end
            end
            FOUND: begin
                start_shifting <= 1; // set start_shifting once we reach FOUND
            end
            default: state <= IDLE; // catch-all for invalid states
        endcase
    end
end

initial begin
    state = IDLE;
    start_shifting = 0;
end

endmodule