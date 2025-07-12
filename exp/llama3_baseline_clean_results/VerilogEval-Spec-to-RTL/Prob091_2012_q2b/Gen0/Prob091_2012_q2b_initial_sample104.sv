module TopModule(
    input  [5:0] y,  // current state
    input  w,       // input
    output Y1,      // input of state flip-flop y[1]
    output Y3       // input of state flip-flop y[3]
);

// Current state decoding
wire currentStateA = (y[0] == 1'b1) && (y[1] == 1'b0) && (y[2] == 1'b0) && (y[3] == 1'b0) && (y[4] == 1'b0) && (y[5] == 1'b0);
wire currentStateB = (y[0] == 1'b0) && (y[1] == 1'b1) && (y[2] == 1'b0) && (y[3] == 1'b0) && (y[4] == 1'b0) && (y[5] == 1'b0);
wire currentStateC = (y[0] == 1'b0) && (y[1] == 1'b0) && (y[2] == 1'b1) && (y[3] == 1'b0) && (y[4] == 1'b0) && (y[5] == 1'b0);
wire currentStateD = (y[0] == 1'b0) && (y[1] == 1'b0) && (y[2] == 1'b0) && (y[3] == 1'b1) && (y[4] == 1'b0) && (y[5] == 1'b0);
wire currentStateE = (y[0] == 1'b0) && (y[1] == 1'b0) && (y[2] == 1'b0) && (y[3] == 1'b0) && (y[4] == 1'b1) && (y[5] == 1'b0);
wire currentStateF = (y[0] == 1'b0) && (y[1] == 1'b0) && (y[2] == 1'b0) && (y[3] == 1'b0) && (y[4] == 1'b0) && (y[5] == 1'b1);

// Next state decoding for Y1
assign Y1 = (currentStateA && ~w) || 
            (currentStateB && ~w) || 
            (currentStateC && ~w) || 
            (currentStateD && ~w) || 
            (currentStateE && ~w) || 
            (currentStateD && w);

// Next state decoding for Y3
assign Y3 = (currentStateB && ~w) || 
            (currentStateC && ~w) || 
            (currentStateD && ~w) || 
            (currentStateE && ~w) || 
            (currentStateD && w);

endmodule