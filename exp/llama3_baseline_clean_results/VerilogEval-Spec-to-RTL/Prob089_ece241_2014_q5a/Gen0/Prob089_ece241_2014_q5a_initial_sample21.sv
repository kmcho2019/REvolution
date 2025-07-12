module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // Idle, Running
reg seen_one; // flag to indicate whether we have seen at least one '1'
reg invert; // flag to indicate whether we should invert the output
reg output; // internal output register

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // Idle
        seen_one <= 1'b0;
        invert <= 1'b0;
        output <= 1'b0;
    end else begin
        case(state)
            0: begin // Idle
                if(x) begin
                    state <= 1; // Running
                    seen_one <= 1'b1;
                    invert <= 1'b1;
                    output <= ~x;
                end else begin
                    state <= 0;
                    seen_one <= 1'b0;
                    invert <= 1'b0;
                    output <= 1'b0;
                end
            end
            1: begin // Running
                if(x) begin
                    state <= 1;
                    seen_one <= 1'b1;
                    output <= ~x;
                end else begin
                    state <= 1;
                    output <= ~x;
                end
            end
            default: state <= 0;
        endcase
    end
end

// Combinational logic
always @(*) begin
    if(seen_one && invert) begin
        z = output;
    end else begin
        z = 1'b0;
    end
end

endmodule