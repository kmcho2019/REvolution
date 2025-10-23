module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] counter;
    reg [2:0] w_samples;

    // State transition and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 2'b0;
            w_samples <= 3'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        counter <= 2'b0;
                        w_samples <= 3'b0;
                    end
                end
                B: begin
                    counter <= (counter == 2'b10) ? 2'b0 : counter + 1'b1;
                    w_samples <= {w_samples[1:0], w};
                end
            endcase
        end
    end

    // Output logic
    wire [1:0] sum = w_samples[0] + w_samples[1] + w_samples[2];
    assign z = (state == B) && (counter == 2'b0) && (sum == 2'd2);

endmodule