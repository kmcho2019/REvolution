module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [2:0] state; // Simplified to 3 bits for fewer states
reg [2:0] ones; // Counter for consecutive ones

localparam IDLE = 3'b000;
localparam COUNTING = 3'b001;
localparam FLAG = 3'b010;
localparam ERROR = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones <= 0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= COUNTING;
                    ones <= 1;
                end
            end
            COUNTING: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones == 5) begin
                        // Prepare to discard if next bit is 0
                        state <= FLAG;
                    end else if (ones >= 7) begin
                        state <= ERROR;
                    end
                end else if (ones == 5) begin
                    // Discard bit after 5 consecutive ones
                    disc <= 1;
                    state <= IDLE;
                    ones <= 0;
                end else if (ones == 6) begin
                    // Flag after 6 consecutive ones
                    flag <= 1;
                    state <= IDLE;
                    ones <= 0;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                end
            end
            FLAG: begin
                if (in) begin
                    state <= ERROR;
                end else begin
                    flag <= 1; // Confirm flag
                    state <= IDLE;
                    ones <= 0;
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                    ones <= 0;
                    err <= 0;
                end else begin
                    err <= 1; // Continue error state
                end
            end
        endcase
    end
end

// Reset output signals on the next clock cycle
always @(posedge clk) begin
    if (~reset) begin
        if (state == IDLE || state == COUNTING || state == ERROR) begin
            disc <= 0;
            flag <= 0;
        end
        if (state != ERROR) begin
            err <= 0;
        end
    end
end

endmodule