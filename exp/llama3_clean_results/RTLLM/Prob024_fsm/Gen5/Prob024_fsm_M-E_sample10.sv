module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Counter to track the progression through the sequence
logic [2:0] counter;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 3'b000;
        MATCH <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                if (IN == 1'b1) begin
                    counter <= 3'b001;
                end else begin
                    counter <= 3'b000;
                end
            end
            3'b001: begin
                if (IN == 1'b0) begin
                    counter <= 3'b010;
                end else begin
                    counter <= 3'b000;
                end
            end
            3'b010: begin
                if (IN == 1'b0) begin
                    counter <= 3'b011;
                end else begin
                    counter <= 3'b000;
                end
            end
            3'b011: begin
                if (IN == 1'b1) begin
                    counter <= 3'b100;
                end else begin
                    counter <= 3'b000;
                end
            end
            3'b100: begin
                if (IN == 1'b1) begin
                    counter <= 3'b000;
                    MATCH <= 1'b1;
                end else begin
                    counter <= 3'b000;
                end
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

// Combinational logic to reset MATCH after one clock cycle
always_comb begin
    if (MATCH == 1'b1) begin
        MATCH <= 1'b0;
    end
end

endmodule