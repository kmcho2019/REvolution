module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states
enum logic [1:0] {LOW, LOW_MID, MID_HIGH, HIGH} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (state)
            LOW: begin
                if (s == 3'b000) begin
                    next_state <= LOW;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s == 3'b001) begin
                    next_state <= LOW_MID;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else begin
                    next_state <= LOW;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            LOW_MID: begin
                if (s == 3'b000) begin
                    next_state <= LOW;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b001) begin
                    next_state <= LOW_MID;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b011) begin
                    next_state <= MID_HIGH;
                    fr2 <= 1'b1;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    next_state <= LOW_MID;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            MID_HIGH: begin
                if (s == 3'b000) begin
                    next_state <= LOW;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b001) begin
                    next_state <= LOW_MID;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b011) begin
                    next_state <= MID_HIGH;
                    fr2 <= 1'b1;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s == 3'b111) begin
                    next_state <= HIGH;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b1;
                end else begin
                    next_state <= MID_HIGH;
                    fr2 <= 1'b1;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            HIGH: begin
                if (s == 3'b111) begin
                    next_state <= HIGH;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end else begin
                    next_state <= HIGH;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b1;
                end
            end
            default: begin
                next_state <= LOW;
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
        state <= next_state;
    end
end

endmodule