module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] prevState;
reg [1:0] level; // to track the previous level

// Initial state
initial begin
    state = 3'b111; // all sensors asserted
    prevState = 3'b000; // no sensors asserted
    level = 2'b11; // previous level was low
    fr2 = 1'b0;
    fr1 = 1'b0;
    fr0 = 1'b0;
    dfr = 1'b0;
end

// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state = 3'b000; // no sensors asserted
        prevState = 3'b000; // no sensors asserted
        level = 2'b00; // previous level was low
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b1;
    end else begin
        // Determine the current state based on the water level
        if (s == 3'b111) begin // above s[2]
            state = 3'b111; // all sensors asserted
            level = 2'b11; // previous level was high
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end else if (s == 3'b110) begin // between s[2] and s[1]
            state = 3'b110; // s[0] and s[1] asserted
            if (prevState == 3'b000 || prevState == 3'b001) begin // previous level was low
                level = 2'b01; // previous level was low
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                level = 2'b10; // previous level was high
                fr2 = 1'b0;
                fr1 = 1'b0;
                fr0 = 1'b1;
                dfr = 1'b0;
            end
        end else if (s == 3'b100) begin // between s[1] and s[0]
            state = 3'b100; // s[0] asserted
            if (prevState == 3'b000) begin // previous level was low
                level = 2'b01; // previous level was low
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b1;
            end else begin
                level = 2'b10; // previous level was high
                fr2 = 1'b0;
                fr1 = 1'b1;
                fr0 = 1'b1;
                dfr = 1'b0;
            end
        end else begin // below s[0]
            state = 3'b000; // no sensors asserted
            level = 2'b01; // previous level was low
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        // Update the previous state
        prevState = state;
    end
end
endmodule