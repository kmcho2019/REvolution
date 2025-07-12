module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

// Distributed memory
always @(posedge clk) begin
    if (enable) begin
        Q[7] <= S;
        for (int i = 6; i >= 0; i--) begin
            Q[i] <= Q[i+1];
        end
    end
end

// Tree-like multiplexer structure
reg [7:0] mux_out;
always @(*) begin
    // Level 1: Select between Q[0-3] and Q[4-7] based on A
    if (A == 0) begin
        // Level 2: Select between Q[0-1] and Q[2-3] based on B
        if (B == 0) begin
            // Level 3: Select between Q[0] and Q[1] based on C
            if (C == 0) begin
                mux_out = Q[0];
            end else begin
                mux_out = Q[1];
            end
        end else begin
            // Level 3: Select between Q[2] and Q[3] based on C
            if (C == 0) begin
                mux_out = Q[2];
            end else begin
                mux_out = Q[3];
            end
        end
    end else begin
        // Level 2: Select between Q[4-5] and Q[6-7] based on B
        if (B == 0) begin
            // Level 3: Select between Q[4] and Q[5] based on C
            if (C == 0) begin
                mux_out = Q[4];
            end else begin
                mux_out = Q[5];
            end
        end else begin
            // Level 3: Select between Q[6] and Q[7] based on C
            if (C == 0) begin
                mux_out = Q[6];
            end else begin
                mux_out = Q[7];
            end
        end
    end
end

assign Z = mux_out;

endmodule