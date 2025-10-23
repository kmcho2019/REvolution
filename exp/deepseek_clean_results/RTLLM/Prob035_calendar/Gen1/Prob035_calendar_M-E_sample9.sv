module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [17:0] time_counter;

// Unified counter implementation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        time_counter <= 18'd0;
    end else begin
        // Handle seconds rollover
        if (time_counter[5:0] == 6'd59) begin
            time_counter[5:0] <= 6'd0;
            // Handle minutes rollover
            if (time_counter[11:6] == 6'd59) begin
                time_counter[11:6] <= 6'd0;
                // Handle hours rollover
                if (time_counter[16:12] == 5'd23) begin
                    time_counter[16:12] <= 5'd0;
                end else begin
                    time_counter[16:12] <= time_counter[16:12] + 5'd1;
                end
            end else begin
                time_counter[11:6] <= time_counter[11:6] + 6'd1;
            end
        end else begin
            time_counter[5:0] <= time_counter[5:0] + 6'd1;
        end
    end
end

// Output assignments
always @(*) begin
    Secs = time_counter[5:0];
    Mins = time_counter[11:6];
    Hours = {1'b0, time_counter[16:12]}; // Zero-extend to 6 bits
end

endmodule